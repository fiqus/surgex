const axios = require("axios"),
  {apiURL, buildHeaders, checkStatus, setupLoader} = require("./index");

const client = axios.create({baseURL: apiURL, timeout: 0, headers: {}});

setupLoader(client);

function httpGet(url) {
  return client.get(url, {headers: buildHeaders()})
    .then((response) => {
      return checkStatus(response);
    });
}

function httpPost(url, data) {
  return client.post(url, data, {headers: buildHeaders()})
    .then((response) => {
      return checkStatus(response);
    });
}

function httpPut(url, data) {
  return client.put(url, data, {headers: buildHeaders()})
    .then((response) => {
      return checkStatus(response);
    });
}

function httpDelete(url) {
  return client.delete(url, {headers: buildHeaders()})
    .then((response) => {
      return checkStatus(response);
    });
}

module.exports = {
  httpGet,
  httpPost,
  httpPut,
  httpDelete
}