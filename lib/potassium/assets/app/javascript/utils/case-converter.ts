// From https://github.com/domchristie/humps/issues/51#issuecomment-425113505
/* eslint-disable complexity */
/* eslint-disable max-statements */
import { camelize, decamelize } from 'humps';

export type objectToConvert = File | FormData | Blob | Record<string, unknown> | Array<objectToConvert>;

function convertKeys(
  object: objectToConvert,
  conversion: 'camelize' | 'decamelize',
): objectToConvert {
  const converter = {
    camelize,
    decamelize,
  };
  if (object && !(object instanceof File) && !(object instanceof Blob)) {
    if (object instanceof Array) {
      return object.map((item: objectToConvert) => convertKeys(item, conversion));
    }
    if (object instanceof FormData) {
      const formData = new FormData();
      for (const [key, value] of object.entries()) {
        formData.append(converter[conversion](key), value);
      }

      return formData;
    }
    if (typeof object === 'object') {
      return Object.keys(object).reduce((acc, next) => ({
        ...acc,
        [converter[conversion](next)]: convertKeys(object[next] as objectToConvert, conversion),
      }), {});
    }
  }

  return object;
}

export default convertKeys;
