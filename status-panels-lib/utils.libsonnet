local join(a) =
  local notNull(i) = i != null;
  local maybeFlatten(acc, i) = if std.type(i) == 'array' then acc + i else acc + [i];
  std.foldl(maybeFlatten, std.filter(notNull, a), []);
{
  local this = self,
  join: join,
}
