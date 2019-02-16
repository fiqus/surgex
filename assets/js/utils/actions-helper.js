const apiClient = require("./api-client");

export function deleteItem({component, onSuccess, onError, url, question, loadingMsg, okMsg, errMsg}) {
  component.$awn.confirm(question, () => {
    component.$awn.asyncBlock(
      apiClient.httpDelete(url),
      (rs) => {
        component.$awn.success(okMsg);
        return onSuccess(rs);
      },
      errMsg,
      loadingMsg
    ).catch(onError || (() => {}));
  });
}

export function updateItem({component, onSuccess, onError, onResponse, url, data, loadingMsg, okMsg, errMsg}) {
  component.$awn.asyncBlock(
    apiClient.httpPut(url, data).then(onResponse),
    (rs) => {
      component.$awn.success(okMsg);
      return onSuccess(rs);
    },
    errMsg,
    loadingMsg
  ).catch(onError || (() => {}));
}

export function createItem({component, onSuccess, onError, onResponse, url, data, loadingMsg, okMsg, errMsg}) {
  component.$awn.asyncBlock(
    apiClient.httpPost(url, data).then(onResponse),
    (rs) => {
      component.$awn.success(okMsg);
      return onSuccess(rs);
    },
    errMsg,
    loadingMsg
  ).catch(onError || (() => {}));
}