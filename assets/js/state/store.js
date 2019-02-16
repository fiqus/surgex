const apiClient = require("../utils/api-client");

const initialState = {
  authUser: null,
  token: null,
  patient: null,
  surgeries: []
};

function deleteItem({component, success, error, question, url, loadingMsg, okMsg, errMsg}) {
  component.$awn.confirm(question, () => {
    component.$awn.asyncBlock(
      apiClient.httpDelete(url),
      (rs) => {
        component.$awn.success(okMsg);
        return success(rs);
      },
      errMsg,
      loadingMsg
    ).catch(error || (() => {}));
  });
}

const actions = {
  proccessApiResponse(res) {
    if (res.status === 401) {
      return actions.logout();
    }

    return res.data;
  },
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
      .then(actions.proccessApiResponse);
  },
  fetchPatient({commit}, {patientId}) {
    return apiClient.httpGet(`/patients/${patientId}`)
      .then(actions.proccessApiResponse)
      .then((patient) => {
        // @TODO This shouldn't be needed anymore!
        commit("setPatient", patient);
      });
  },
  createPatient(_, dataPatient) {
    return apiClient.httpPost("/patients", dataPatient)
      .then(actions.proccessApiResponse);
  },
  updatePatient(_, dataPatient) {
    const data = {
      id: dataPatient.id,
      patient: {
        first_name: dataPatient.first_name,
        last_name: dataPatient.last_name,
        medical_history: dataPatient.medical_history,
        address: dataPatient.address,
        city: dataPatient.city,
        province: dataPatient.province,
        birthdate: dataPatient.birthdate
      }
    };
    return apiClient.httpPut(`/patients/${dataPatient.id}`, data)
      .then(actions.proccessApiResponse);
  },
  deletePatient(_, patientId) {
    return apiClient.httpDelete(`/patients/${patientId}`)
      .then(actions.proccessApiResponse);
  },
  fetchUsers() {
    return apiClient.httpGet("/users")
      .then(actions.proccessApiResponse);
  },
  fetchUser(_, userId) {
    return apiClient.httpGet(`/users/${userId}`)
      .then(actions.proccessApiResponse);
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
      .then(actions.proccessApiResponse);
  },
  fetchSurgeons() {
    return apiClient.httpGet("/surgeons")
      .then(actions.proccessApiResponse);
  },
  fetchSurgeon(_, surgeonId) {
    return apiClient.httpGet(`/surgeons/${surgeonId}`)
      .then(actions.proccessApiResponse);
  },
  deleteSurgeon(_, {component, surgeon, success, error}) {
    deleteItem({component, success, error,
      question: `¿Eliminar al cirujano ${surgeon.lastName}, ${surgeon.firstName}?`,
      url: `/surgeons/${surgeon.id}`,
      loadingMsg: "Eliminando cirujano",
      okMsg: "El cirujano ha sido eliminado.",
      errMsg: "El cirujano no pudo ser eliminado."
    });
  },
  updateSurgeon(_, surgeon) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: surgeon.id,
      surgeon: {
        first_name: surgeon.firstName,
        last_name: surgeon.lastName,
        email: surgeon.email,
        license: surgeon.license
      }
    };

    return apiClient.httpPut(`/surgeons/${surgeon.id}`, data)
      .then(actions.proccessApiResponse);
  },
  createSurgeon(_, surgeon) {
    const data = {
      user: {
        is_admin: false
      },
      surgeon: {
        first_name: surgeon.firstName,
        last_name: surgeon.lastName,
        email: surgeon.email,
        license: surgeon.license
      }
    };

    return apiClient.httpPost("/surgeons", data)
      .then(actions.proccessApiResponse);
  },
  fetchSurgeries({commit}) {
    return apiClient.httpGet("/surgeries")
      .then(actions.proccessApiResponse)
      .then((surgeries) => {
        // @TODO This shouldn't be needed anymore!
        commit("setSurgeries", surgeries);
      });
  }
};

const mutations = {
  setAuthUser(state, authUser) {
    state.authUser = authUser.user;
    state.token = authUser.token;
  },
  // @TODO This shouldn't be needed anymore!
  setPatient(state, patient) {
    state.patient = patient;
  },
  // @TODO This shouldn't be needed anymore!
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