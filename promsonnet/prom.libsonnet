{
  v1: {
    ruleGroupSet: {
      new():: {
        groups_map:: {},
        groups_order:: [],
        patch_rules_all:: [],
        local groups_map = self.groups_map,
        local groups_order = self.groups_order,
        local patch_rules_all = self.patch_rules_all,
        groups: [
          local group = groups_map[group_name];
          {
            name: group_name,
            rules: [
              local rule = group.rules_map[rule_name];
              std.foldl(function(rule, patch) rule + patch, patch_rules_all + group.patches, rule)
              for rule_name in group.rules_order
            ],
          }
          for group_name in groups_order
        ],
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
        patches:: [],
        local rules_map = self.rules_map,
        local rules_order = self.rules_order,
      },

      rule: {
        newAlert(name, rule):: {
          rules_map+:: {
            [name]: rule { alert: name },
          },
          rules_order+:: [name],
        },
        newRecording(name, rule):: {
          rules_map+:: {
            [name]: rule { record: name },
          },
          rules_order+:: [name],
        },
      },
    },

    patchRule(group, rule, patch):: {
      groups_map+:: {
        [group]+: {
          rules_map+:: {
            [rule]+: patch,
          },
        },
      },
    },

    patchGroup(group, patch):: {
      groups_map+:: {
        [group]+: {
          patches+: [patch],
        },
      },
    },

    patchAll(patch):: {
      patch_rules_all+:: [patch],
    },
  },
}
