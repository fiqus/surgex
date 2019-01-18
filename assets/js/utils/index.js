import store from "../app"

const { socketScheme, scheme, hostname } =
  process.env.NODE_ENV === 'production'
  ? { socketScheme: 'wss'
    , scheme: 'https'
    , hostname: window.location.hostname }
  : { socketScheme: 'ws'
    , scheme: 'http'
    , hostname: 'localhost:4000' };

const defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
}

export function buildHeaders() {
  const token = store.getters.getToken;

  if (token) {
    return Object.assign({}, defaultHeaders, {
      "Authorization": `Bearer ${token}`
    });
  }

  return defaultHeaders;
}

export const apiURL = `${scheme}://${hostname}/api`;

export function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response.data;
  } else {
    var error = new Error(response.statusText)
    error.response = response
    throw error
  }
}
