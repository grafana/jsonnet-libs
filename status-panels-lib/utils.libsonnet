local join(a) =
  local notNull(i) = i != null;
  local flatten(acc, i) = acc + i;
  std.foldl(flatten, std.filter(notNull, a), []);
{
  local this = self,
  join: join,
}
