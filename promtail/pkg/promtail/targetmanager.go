package promtail

import (
	"context"
	"strings"

	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"
	"github.com/prometheus/common/model"
	"github.com/prometheus/prometheus/config"
	"github.com/prometheus/prometheus/discovery"
	"github.com/prometheus/prometheus/relabel"
)

const (
	pathLabel = "__path__"
)

type NewTargetFunc func(path string, labels model.LabelSet) (*Target, error)

type TargetManager struct {
	syncers []*syncer

	log  log.Logger
	quit context.CancelFunc
}

func NewTargetManager(
	logger log.Logger,
	scrapeConfig []ScrapeConfig,
	fn NewTargetFunc,
) *TargetManager {
	ctx, quit := context.WithCancel(context.Background())

	tm := &TargetManager{
		log:  logger,
		quit: quit,
	}

	for _, cfg := range scrapeConfig {
		s := &syncer{
			log:           logger,
			newTarget:     fn,
			relabelConfig: cfg.RelabelConfigs,
			targets:       map[string]*Target{},
		}
		tm.syncers = append(tm.syncers, s)

		ts := discovery.NewTargetSet(s)
		ts.UpdateProviders(
			discovery.ProvidersFromConfig(cfg.ServiceDiscoveryConfig,
				log.With(tm.log, "component", "discovery")))
		go ts.Run(ctx)
	}

	return tm
}

func (tm *TargetManager) Stop() {
	tm.quit()

	for _, s := range tm.syncers {
		s.stop()
	}
}

type syncer struct {
	log           log.Logger
	newTarget     NewTargetFunc
	targets       map[string]*Target
	relabelConfig []*config.RelabelConfig
}

func (s *syncer) Sync(groups []*config.TargetGroup) {
	targets := map[string]struct{}{}

	for _, group := range groups {
		for _, t := range group.Targets {
			labels := group.Labels.Merge(t)
			labels = relabel.Process(labels, s.relabelConfig...)
			// Drop empty targets (drop in relabeling).
			if len(labels) == 0 {
				continue
			}

			path, ok := labels[pathLabel]
			if !ok {
				level.Info(s.log).Log("msg", "no path for target", "labels", labels.String())
				continue
			}

			for k := range labels {
				if strings.HasPrefix(string(k), "__") {
					delete(labels, k)
				}
			}

			key := labels.String()
			targets[key] = struct{}{}
			if _, ok := s.targets[key]; ok {
				continue
			}

			level.Info(s.log).Log("msg", "Adding target", "key", key)
			t, err := s.newTarget(string(path), labels)
			if err != nil {
				level.Error(s.log).Log("msg", "Failed to create target", "key", key, "error", err)
				continue
			}

			s.targets[key] = t
		}
	}

	for key, target := range s.targets {
		if _, ok := targets[key]; !ok {
			level.Info(s.log).Log("msg", "Removing target", "key", key)
			target.Stop()
			delete(s.targets, key)
		}
	}
}

func (s *syncer) stop() {
	for key, target := range s.targets {
		level.Info(s.log).Log("msg", "Removing target", "key", key)
		target.Stop()
		delete(s.targets, key)
	}
}
