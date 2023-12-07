local date = import 'date.jsonnet';
local test = import 'github.com/yugui/jsonnetunit/jsonnetunit/test.libsonnet';

// Run this test suite by running:
// jsonnet -J vendor date_test.jsonnet
test.suite({
  'test 1970-01-01 00:00:00 (zero)': {
    actual: date.to_unix_timestamp(1970, 1, 1, 0, 0, 0),
    expect: 0,
  },
  'test 1970-01-02 00:00:00 (one day)': {
    actual: date.to_unix_timestamp(1970, 1, 2, 0, 0, 0),
    expect: 86400,
  },
  'test 1971-01-01 00:00:00 (one year)': {
    actual: date.to_unix_timestamp(1971, 1, 1, 0, 0, 0),
    expect: 365 * 24 * 3600,
  },
  'test 1972-03-01 00:00:00 (month of leap year)': {
    actual: date.to_unix_timestamp(1972, 3, 1, 0, 0, 0),
    expect: 2 * 365 * 24 * 3600 + 31 * 24 * 3600 + 29 * 24 * 3600,
  },
  'test 1974-01-01 00:00:00 (incl leap year)': {
    actual: date.to_unix_timestamp(1974, 1, 1, 0, 0, 0),
    expect: (4 * 365 + 1) * 24 * 3600,
  },
  'test 2020-01-02 03:04:05 (full date)': {
    actual: date.to_unix_timestamp(2020, 1, 2, 3, 4, 5),
    expect: 1577934245,
  },
})
