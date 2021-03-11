{
  // In this file, the word 'update' refers to retrofitting maps and _order
  // lists to data structures that lack them.

  v1: {
    local v1 = self,
    ruleGroupSet: {
      update():: {
        local groups = super.groups,
        local this = self,
        local groupsAsMap(group, acc) = acc { [group.name]+: group + v1.ruleGroup.update() },
        local groupsAsList(group, acc) = acc + [group.name],
        groups_map:: std.foldr(groupsAsMap, groups, {}),
        groups_order:: std.foldr(groupsAsList, groups, []),
        groups: [this.groups_map[group] for group in this.groups_order],
      },
    },

    patchRule(group, rule, patch):: {
      groups: std.map(function(g)
                        if g.name == group
                        then g {
                          rules: std.map(function(r)
                                           if ('alert' in r && r.alert == rule) ||
                                              ('record' in r && r.record == rule)
                                           then r + patch
                                           else r,
                                         g.rules),
                        }
                        else g,
                      super.groups),
    },

    ruleGroup: {
      update():: {
        local rules = super.rules,
        local this = self,
        local ruleName(rule) = if 'alert' in rule then rule.alert else rule.record,
        local rulesAsMap(rule, acc) = acc { [ruleName(rule)]: rule },
        local rulesAsList(rule, acc) = acc + [ruleName(rule)],
        rules_map:: std.foldr(rulesAsMap, rules, {}),
        rules_order:: std.foldr(rulesAsList, rules, []),
        rules: [this.rules_map[rule] for rule in this.rules_order],
      },
    },

    mixin: {
      update():: {
        prometheusRules+: v1.ruleGroupSet.update(),
        prometheusAlerts+: v1.ruleGroupSet.update(),
      },
      updateExisting(mixin):: {
        [mixin]+: $.v1.mixin.update(),
      },
    },
  },
}
