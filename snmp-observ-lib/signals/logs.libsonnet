local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.logsFilteringSelector,
    groupLabels: this.logsGroupLabels,
    instanceLabels: this.logsInstanceLabels,
    aggLevel: 'none',
    aggFunction: 'count',
    enableLokiLogs: this.enableLokiLogs,
    signals: {
      criticalLogs: {
        name: 'Critical logs',
        description: 'Critical logs.',
        type: 'log',
        unit: 'none',
        sources: {
          generic: {
            expr: |||
              {%(queriesSelector)s, level=~"critical|fatal|alert|error"}
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
      allLogs: {
        name: 'All logs',
        description: 'All logs.',
        type: 'log',
        unit: 'none',
        sources: {
          generic: {
            expr: |||
              {%(queriesSelector)s}
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
