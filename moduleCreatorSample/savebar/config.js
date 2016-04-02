import { saveAndNew, saveLink as saveAndEdit } from '../links';

export default {
  METADATA: {depth: 2},

  loggedIn: {
    home: [saveAndNew],
    profile: [saveAndNew],
    center: [saveAndNew],
    search: [saveAndNew]
  },

  notLoggedIn: {
    home: [],
    profile: [],
    center: [],
    search: []
  }
}