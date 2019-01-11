const axios = require("axios"),
  {apiURL, buildHeaders, checkStatus} = require("./index");

const client = axios.create({baseURL: apiURL, timeout: 0, headers: {}});

function httpGet(url) {
  return client.get(url, {headers: buildHeaders()})
    .then((response) => {
      return checkStatus(response);
    });
}

module.exports = {
  httpGet
}