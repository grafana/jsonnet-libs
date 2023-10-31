local days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

local is_leap(year) = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
local leap_year_seconds = 366 * 24 * 3600;
local non_leap_year_seconds = 365 * 24 * 3600;

// year_seconds returns the number of seconds in a year.
local year_seconds(year) = (
  if is_leap(year)
  then leap_year_seconds
  else non_leap_year_seconds
);

// month_seconds returns the number of seconds in a month of a given year.
local month_seconds(year, month) = (
  days_in_month[month - 1] * 24 * 3600
  + if month == 2 && is_leap(year) then 86400 else 0
);

// years_seconds returns the number of seconds in all years up to year-1.
local years_seconds(year) = std.foldl(
  function(acc, y) acc + year_seconds(y),
  std.range(1970, year - 1),
  0,
);

// months_seconds returns the number of seconds in all months up to month-1 of the given year.
local months_seconds(year, month) = std.foldl(
  function(acc, m) acc + month_seconds(year, m),
  std.range(1, month - 1),
  0,
);

// days_seconds returns the number of seconds in all days up to day-1.
local days_seconds(day) = (day - 1) * 24 * 3600;

// is_numeric returns a bool indicating whether the input string is numeric
local is_numeric(input) = std.length(input) > 0 && std.length(std.prune([
  if std.codepoint('0') > std.codepoint(char) || std.codepoint(char) > std.codepoint('9') then char
  for char in std.stringChars(input)
])) == 0;

// parse_date_or_time parses input which has part_names separated by sep.
local parse_date_or_time(input, sep, part_names) = (
  local parts = std.split(input, sep);
  assert std.length(parts) == std.length(part_names) : 'expected %(expected)d parts separated by %(sep)s in %(format)s formatted input "%(input)s", but got %(got)d' % {
    expected: std.length(part_names),
    sep: sep,
    format: std.join(sep, part_names),
    input: input,
    got: std.length(parts),
  };

  {
    [part_names[i]]:
      // Fail with meaningful message if not numeric, otherwise it will be a hell to debug.
      assert is_numeric(parts[i]) : '%(part_name)%s part "%(part)s" of %(format)s of input "%(input)s" is not numeric' % {
        part_name: part_names[i],
        part: parts[i],
        format: std.join(sep, part_names),
        input: input,
      };
      std.parseInt(parts[i])
    for i in std.range(0, std.length(parts) - 1)
  }
);

{
  // to_unix_timestamp transforms a date into a unix timestamp.
  to_unix_timestamp(year, month, day, hour, minute, second)::
    years_seconds(year) + months_seconds(year, month) + days_seconds(day) + hour * 3600 + minute * 60 + second,

  // parse_rfc3339 parses an RFC3339 timestamp in UTC (ending in 'Z') with date and time separated by 'T', like '2006-01-02T15:04:05Z'
  // The returned object has "year", "month", "day", "hour", "minute" and "second" keys, as well as a to_unix_timestamp method that returns the unix timestamp of the parsed date.
  parse_rfc3339(input)::
    assert std.endsWith(input, 'Z') : 'the provided RFC3339 "%s" should end with "Z"' % input;
    local datetime = std.split(std.substr(input, 0, std.length(input) - 1), 'T');
    assert std.length(datetime) == 2 : 'the provided RFC3339 timestamp "%s" does not have date and time parts separated by the character "T"' % input;

    local date = parse_date_or_time(datetime[0], '-', ['year', 'month', 'day']);
    local time = parse_date_or_time(datetime[1], ':', ['hour', 'minute', 'second']);
    date + time + {
      to_unix_timestamp():: $.to_unix_timestamp(self.year, self.month, self.day, self.hour, self.minute, self.second),
    },
}
