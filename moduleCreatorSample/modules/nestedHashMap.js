import _ from 'lodash';

export default function nestedHashMap (inputFunction, depth, hash) {
  if (depth === 0) {
    return inputFunction(hash) // hash might just be a value at this point
  } else {
    return _.mapValues(hash, function (nestedHash) {
      return nestedHashMap(inputFunction, depth - 1, nestedHash)
    })
  }
}