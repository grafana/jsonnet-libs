export function processLabels(labels, grouping) {
  const counters = {};
  const values = {};
  const prefixes = {};

  // Keep count on how many label combinations exist for a timeseries
  labels.forEach(l => {
    const { __name__, ...rest } = l;
    if (!counters[__name__]) counters[__name__] = 0;
    counters[__name__] += 1;

    if (!values[__name__]) values[__name__] = {};
    Object.keys(rest).forEach(key => {
      if (!values[__name__][key]) values[__name__][key] = [];
      if (values[__name__][key].indexOf(rest[key]) === -1)
        values[__name__][key].push(rest[key]);
    });
  });

  let metrics = Object.keys(counters);
  const metricsCount = metrics.length;
  const totalCount = labels.length;

  // Remove metrics that only have a couple of timeseries
  metrics = metrics.filter(n => counters[n] > 2);

  metrics.forEach(name => {
    const prefix = name.split('_').shift();
    if (!prefixes[prefix]) prefixes[prefix] = [];

    const children = Object.keys(values[name]).map(k => ({
      name: k,
      key: name + k,
      prefix,
      size: values[name][k].length,
    }));
    prefixes[prefix].push({ name, children, prefix, key: name });
  });

  const children = Object.keys(prefixes).map(k => ({
    name: k,
    prefix: k,
    key: k,
    children: prefixes[k],
  }));

  const grouped = findGrouping(labels, grouping);
  const groupedCount = grouped.count;

  return {
    grouped,
    groupedCount,
    metrics: {
      root: { name: 'Prometheus', children, key: 'ROOT', },
    },
    metricsCount,
    totalCount,
  };
}

function findGrouping(labels, grouping) {
  const grouped = {};
  let others = 0;
  labels.forEach(l => {
    const label = l[grouping];
    if (label) {
      grouped[label] = grouped[label] ? grouped[label] + 1 : 1;
    } else {
      others += 1;
    }
  });

  const children = Object.keys(grouped).map(j => ({
    name: j,
    key: j,
    size: grouped[j],
  }));
  children.push({ name: 'Others', key: 'OTHERS', size: others });
  const count = others + children.length;

  return { root: { name: grouping, children, key: 'ROOT' }, count };
}
