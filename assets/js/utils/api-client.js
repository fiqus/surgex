const {createApiClient, buildHeaders, checkStatus} = require("./index");

const client = createApiClient();

function httpGet(url, params = {}) {
  return client.get(url, {headers: buildHeaders(), params})
    .then(checkStatus, checkStatus);
}

function httpPost(url, data) {
  return client.post(url, data, {headers: buildHeaders()})
    .then(checkStatus, checkStatus);
}

function httpPut(url, data) {
  return client.put(url, data, {headers: buildHeaders()})
    .then(checkStatus, checkStatus);
}

function httpDelete(url) {
  return client.delete(url, {headers: buildHeaders()})
    .then(checkStatus, checkStatus);
}

module.exports = {
  httpGet,
  httpPost,
  httpPut,
  httpDelete
}