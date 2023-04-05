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

// month offset lookup tables for day of week calculation
local common_year_month_offset = [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5];
local leap_year_month_offset = [0, 3, 4, 0, 2, 5, 0, 3, 6, 1, 4, 6];

// month_offset looks up the month offset for day of week calculations based on weather the year is common or leap
local month_offset(year, month) = if is_leap(year) then leap_year_month_offset[month-1] else common_year_month_offset[month-1];

{
  // to_unix_timestamp transforms a date into a unix timestamp.
  to_unix_timestamp(year, month, day, hour, minute, second)::
    years_seconds(year) + months_seconds(year, month) + days_seconds(day) + hour * 3600 + minute * 60 + second,
  
  // day_of_week calculates the day of the week for a given date using Gauss's algorithm (0=Sunday, 1=Monday, etc.)
  day_of_week(year, month, day)::
    (day + month_offset(year, month) + 5*((year-1)%4) + 4*((year-1)%100) + 6*((year-1)%400))%7
}
