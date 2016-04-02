import { homeLink,
         logInLink,
         logOutLink,
         selfProfileLink,
         chromeExtensionLink,
         saveLink } from '../links';

const loggedInBase = [selfProfileLink, homeLink, chromeExtensionLink, logOutLink];
const notLoggedInBase = [homeLink, logInLink];

export default {
  METADATA: {depth: 2},
  loggedIn: {
    home: loggedInBase,
    profile: loggedInBase,
    center: loggedInBase,
    search: loggedInBase
  },

  notLoggedIn: {
    home: notLoggedInBase,
    profile: notLoggedInBase,
    center: notLoggedInBase,
    search: notLoggedInBase
  }
}