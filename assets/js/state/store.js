const apiClient = require("../utils/api-client");

const initialState = {
  authUser: null,
  token: null,
  patient: null
};

const actions = {
  login({commit}, data) {
    return apiClient.httpPost("/token", data)
      .then((res) => {
        commit("setAuthUser", res);
      });
  },
  fetchPatient({commit}, {patientId}) {
    return apiClient.httpGet(`/patients/${patientId}`)
      .then((patient) => {
        commit("setPatient", patient);
      });
  }
};

const mutations = {
  setPatient(state, patient) {
    state.patient = patient;
  },
  setAuthUser(state, authUser) {
    state.authUser = authUser.user;
    state.token = authUser.token;
  }
};

const getters = {
  getToken(state) {
    return state.token;
  }
};

module.exports = {
  initialState,
  getters,
  mutations,
  actions
};