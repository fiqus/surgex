const apiClient = require("../utils/api-client");

const initialState = {
  authUser: null,
  token: null,
  patient: null,
  surgeries: []
};

const actions = {
  login({commit}, data) {
    return apiClient.httpPost("/token", data)
      .then((res) => {
        commit("setAuthUser", res);
      });
  },
  logout() {
    localStorage.clear();
    return window.location.reload();
  },
  fetchPatients() {
    return apiClient.httpGet("/patients")
      .then((res) => {
        return res.data;
      });
  },
  fetchPatient({commit}, {patientId}) {
    return apiClient.httpGet(`/patients/${patientId}`)
      .then((patient) => {
        commit("setPatient", patient);
      });
  },
  createPatient({commit}, dataPatient) {
    return apiClient.httpPost("/patients", dataPatient)
      .then((res) => {
        return res;
      });
  },
  fetchUsers() {
    return apiClient.httpGet("/users")
      .then((res) => {
        return res.data;
      });
  },
  fetchUser(_, userId) {
    return apiClient.httpGet(`/users/${userId}`)
      .then((res) => {
        return res.data;
      });
  },
  updateUser(_, user) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: user.id,
      user: {
        is_admin: user.isAdmin,
        disabled: user.disabled
      }
    };

    return apiClient.httpPut(`/users/${user.id}`, data)
      .then((res) => {
        return res.data;
      });
  },
  fetchSurgeons() {
    return apiClient.httpGet("/surgeons")
      .then((res) => {
        return res.data;
      });
  },
  fetchSurgeon(_, surgeonId) {
    return apiClient.httpGet(`/surgeons/${surgeonId}`)
      .then((res) => {
        return res.data;
      });
  },
  deleteSurgeon(_, surgeonId) {
    return apiClient.httpDelete(`/surgeons/${surgeonId}`)
      .then((res) => {
        return res.data;
      });
  },
  fetchSurgeries({commit}) {
    return apiClient.httpGet("/surgeries")
      .then((res) => {
        commit("setSurgeries", res.data);
      });
  }
};

const mutations = {
  setAuthUser(state, authUser) {
    state.authUser = authUser.user;
    state.token = authUser.token;
  },
  setPatient(state, patient) {
    state.patient = patient.data;
  },
  setSurgeries(state, surgeries) {
    state.surgeries = surgeries;
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