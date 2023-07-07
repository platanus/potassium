import { decamelizeKeys } from 'humps';
import { stringify } from 'qs';

export function paramsSerializer(params: object) {
  const decamelizedParams = decamelizeKeys(params);

  return stringify(decamelizedParams, { arrayFormat: 'brackets' });
}
