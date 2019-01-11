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

// usefull when implement auth
export function buildHeaders() {
  // const authToken = localStorage.getItem('id_token')

  return new Headers(Object.assign({}, defaultHeaders, {
    // Authorization: authToken
  }))
}

export const apiURL = `${scheme}://${hostname}/api`;

export function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response.data.data;
  } else {
    var error = new Error(response.statusText)
    error.response = response
    throw error
  }
}
