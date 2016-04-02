import moduleCreator from '../modules/moduleCreator';
import _ from 'lodash';
import listComponentCreator from './listComponentCreator';

export default function (config, className) {

  const _helper = function (fnArr, props) {
    const comps = _.map(fnArr, (fn, i) => {
      var newProps = {$$store: props.$$store, actions: props.actions, key: i}
      return fn(newProps)
    })
    return listComponentCreator(comps, className)
  }

  return moduleCreator(config, _helper)
}