{
  v1: {
    ruleGroupSet: {
      new():: {
        groups_map:: {},
        groups_order:: [],
        local groups_map = self.groups_map,
        local groups_order = self.groups_order,
        groups: [groups_map[group] for group in groups_order],
      },
      addGroup(group):: {
        groups_map+:: {
          [group.name]: group,
        },
        groups_order+:: [group.name],
      },
    },

    ruleGroup: {
      new(name):: {
        name: name,
        rules_map:: {},
        rules_order:: [],
        local rules_map = self.rules_map,
        local rules_order = self.rules_order,
        rules: [rules_map[rule] for rule in rules_order],
      },

      rule: {
        new(name, rule):: {
          rules_map+:: {
            [name]: rule,
          },
          rules_order+:: [name],
        },
      },
    },
  },
}
