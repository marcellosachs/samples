import _ from 'lodash';
import nestedHashMap from './nestedHashMap';

export default function (config, inputFunction) {

  const _helper = function (configValue) {
    return function (props) {
      return inputFunction(configValue, props)
    }
  }
  // want to hold on to METADATA so that we can compose calls to moduleCreator

  const metadata    = _.pick(config, 'METADATA')
  const nonMetadata = _.omit(config, 'METADATA')

  const x = nestedHashMap(_helper, metadata.METADATA.depth, nonMetadata)
  return _.merge({}, metadata, x)
}