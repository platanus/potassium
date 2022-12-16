import axios, { type AxiosRequestTransformer, type AxiosResponseTransformer } from 'axios';
import convertKeys, { type objectToConvert } from '../utils/case-converter';
import csrfToken from '../utils/csrf-token';

const api = axios.create({
  transformRequest: [
    (data: objectToConvert) => convertKeys(data, 'decamelize'),
    ...(axios.defaults.transformRequest as AxiosRequestTransformer[]),
  ],
  transformResponse: [
    ...(axios.defaults.transformResponse as AxiosResponseTransformer[]),
    (data: objectToConvert) => convertKeys(data, 'camelize'),
  ],
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-CSRF-Token': csrfToken(),
  },
});

export default api;

/*
// Example to use the api object in the path ´app/javascript/api/users.ts´

import api from './index';

export default {
  index() {
    const path = '/api/internal/users';

    return api({
      method: 'get',
      url: path,
    });
  },
  create(data: Partial<User>) {
    const path = '/api/internal/users';

    return api({
      method: 'post',
      url: path,
      data: {
        user: data,
      },
    });
  },
  update(data: Partial<User>) {
    const path = `/api/internal/users/${data.id}`;

    return api({
      method: 'put',
      url: path,
      data: {
        user: data,
      },
    });
  },
};

*/
