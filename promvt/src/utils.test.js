import { processLabels } from './utils';

describe('processLabels', () => {
  const fun = processLabels;
  it('work with empty arguments', () => {
    expect(fun([])).toEqual({metrics:[], jobs: []});
  });
});
