local date = import 'date.jsonnet';
local test = import 'github.com/yugui/jsonnetunit/jsonnetunit/test.libsonnet';

// Run this test suite by running:
// jsonnet -J vendor date_test.jsonnet
test.suite({
  // to_unix_timestamp test cases
  'test to_unix_timestamp 1970-01-01 00:00:00 (zero)': {
    actual: date.to_unix_timestamp(1970, 1, 1, 0, 0, 0),
    expect: 0,
  },
  'test to_unix_timestamp 1970-01-02 00:00:00 (one day)': {
    actual: date.to_unix_timestamp(1970, 1, 2, 0, 0, 0),
    expect: 86400,
  },
  'test to_unix_timestamp 1971-01-01 00:00:00 (one year)': {
    actual: date.to_unix_timestamp(1971, 1, 1, 0, 0, 0),
    expect: 365 * 24 * 3600,
  },
  'test to_unix_timestamp 1972-03-01 00:00:00 (month of leap year)': {
    actual: date.to_unix_timestamp(1972, 3, 1, 0, 0, 0),
    expect: 2 * 365 * 24 * 3600 + 31 * 24 * 3600 + 29 * 24 * 3600,
  },
  'test to_unix_timestamp 1974-01-01 00:00:00 (incl leap year)': {
    actual: date.to_unix_timestamp(1974, 1, 1, 0, 0, 0),
    expect: (4 * 365 + 1) * 24 * 3600,
  },
  'test to_unix_timestamp 2020-01-02 03:04:05 (full date)': {
    actual: date.to_unix_timestamp(2020, 1, 2, 3, 4, 5),
    expect: 1577934245,
  },

  // parse_rfc3339 test cases
  'test parse_rfc3339 1970-01-01T00:00:00Z': {
    actual: date.parse_rfc3339('1970-01-01T00:00:00Z'),
    expect: { year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0 },
  },
  'test parse_rfc3339 2020-01-02T03:04:05Z': {
    actual: date.parse_rfc3339('2020-01-02T03:04:05Z'),
    expect: { year: 2020, month: 1, day: 2, hour: 3, minute: 4, second: 5 },
  },

  // parse_rfc3339(...).to_unix_timestamp() test cases
  'test parse_rfc3339("2020-01-02T03:04:05Z").to_unix_timestamp()': {
    actual: date.parse_rfc3339('2020-01-02T03:04:05Z').to_unix_timestamp(),
    expect: 1577934245,
  },
})
