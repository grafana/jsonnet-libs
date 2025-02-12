// criticalEvents:
//   lokiQuery.new(
//     '${' + variables.datasources.loki.name + '}',
//     '{%(queriesSelector)s, channel="System", level="Critical"} | json' % variables
//   ),
local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'count',
    enableLokiLogs: this.enableLokiLogs,
    discoveryMetric: {
      generic: 'ALERTS',
      arista_sw: self.generic,
      brocade_fc: self.generic,
      brocade_foundry: self.generic,
      cisco: self.generic,
      dell_network: self.generic,
      dlink_des: self.generic,
      extreme: self.generic,
      eltex_mes: self.generic,
      f5_bigip: self.generic,
      fortigate: self.generic,
      hpe: self.generic,
      huawei: self.generic,
      juniper: self.generic,
      mikrotik: self.generic,
      netgear: self.generic,
      qtech: self.generic,
      tplink: self.generic,
      ubiquiti_airos: self.generic,
    },
    signals: {
      alertsCritical: {
        name: 'Critical alert',
        nameShort: 'Critical',
        description: 'Critical alerts.',
        type: 'raw',
        unit: 'none',
        sources: {
          generic: {
            expr: |||
              count by (%(agg)s,alertname) (max_over_time(ALERTS{alertstate="firing", severity="critical", %(queriesSelector)s}[1m]))
                * on(%(agg)s) group_left group by (%(agg)s) (sysUpTime{%(queriesSelector)s})
            |||,
          },
          arista_sw: self.generic,
          brocade_fc: self.generic,
          brocade_foundry: self.generic,
          cisco: self.generic,
          dell_network: self.generic,
          dlink_des: self.generic,
          extreme: self.generic,
          eltex_mes: self.generic,
          f5_bigip: self.generic,
          fortigate: self.generic,
          hpe: self.generic,
          huawei: self.generic,
          juniper: self.generic,
          mikrotik: self.generic,
          netgear: self.generic,
          qtech: self.generic,
          tplink: self.generic,
          ubiquiti_airos: self.generic,
        },
      },
      alertsWarning: {
        name: 'Warning alert',
        nameShort: 'Warnings',
        description: 'Warning alerts.',
        type: 'raw',
        unit: 'none',
        sources: {
          generic: {
            expr: |||
              count by (%(agg)s,alertname) (max_over_time(ALERTS{alertstate="firing", severity="warning", %(queriesSelector)s}[1m]))
                * on(%(agg)s) group_left group by (%(agg)s) (sysUpTime{%(queriesSelector)s})
            |||,
          },
          arista_sw: self.generic,
          brocade_fc: self.generic,
          brocade_foundry: self.generic,
          cisco: self.generic,
          dell_network: self.generic,
          dlink_des: self.generic,
          extreme: self.generic,
          eltex_mes: self.generic,
          f5_bigip: self.generic,
          fortigate: self.generic,
          hpe: self.generic,
          huawei: self.generic,
          juniper: self.generic,
          mikrotik: self.generic,
          netgear: self.generic,
          qtech: self.generic,
          tplink: self.generic,
          ubiquiti_airos: self.generic,
        },
      },

    },
  }
