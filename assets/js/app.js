// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
require("vue-awesome-notifications/dist/styles/style.css");
import css from "../css/app.css"

import "phoenix_html"
import Vue from "vue"
import VueRouter from "vue-router"
import Vuex from "vuex"
import createPersistedState from "vuex-persistedstate"
import VueAWN from "vue-awesome-notifications";

import {initialState, getters, mutations, actions} from "./state/store";

import App from "./App"

import HomeScreen from "./screens/home.vue";
import LoginScreen from "./screens/login.vue";
import PatientsScreen from "./screens/patients/patients-list.vue";
import PatientScreen from "./screens/patients/patient-show.vue";
import PatientCreateScreen from "./screens/patients/new-patient.vue";
import UsersListScreen from "./screens/users/users-list.vue";
import UsersShowScreen from "./screens/users/users-show.vue";
import UsersEditScreen from "./screens/users/users-edit.vue";
import SurgeonsListScreen from "./screens/surgeons/surgeons-list.vue";
import SurgeonsShowScreen from "./screens/surgeons/surgeons-show.vue";
import SurgeonsFormScreen from "./screens/surgeons/surgeons-form.vue";
import SurgeriesScreen from "./screens/sugeries.vue";
import NewSurgeryScreen from "./screens/new-surgery.vue";

const options= {
  labels: {
    tip: "Consejo",
    info: "Información",
    success: "¡Hecho!",
    warning: "Atención",
    alert: "¡Error!",
    async: "Cargando",
    confirm: "Confirmar"
  },
  modal: {okLabel: "Sí", cancelLabel: "No"},
  duration: 5000
}

Vue.config.debug = true;
Vue.config.devtools = true;
Vue.config.silent = false;

Vue.use(VueRouter)
Vue.use(Vuex)
Vue.use(VueAWN, options)

const router = new VueRouter({
  routes: [
    {name: "home", path: "/", component: HomeScreen},
    {name: "login", path: "/login", component: LoginScreen},
    {name: "users-list", path: "/users", component: UsersListScreen},
    {name: "users-show", path: "/users/:userId", component: UsersShowScreen},
    {name: "users-edit", path: "/users/edit/:userId", component: UsersEditScreen},
    {name: "users-activate", path: "/users/password/:userId", component: SurgeonsFormScreen},
    {name: "patients-list", path: "/patients", component: PatientsScreen},
    {name: "patient-show", path: "/patient/:patientId", component: PatientScreen},
    {name: "new-patient", path: "/patients/new", component: PatientCreateScreen},
    {name: "surgeons-list", path: "/surgeons", component: SurgeonsListScreen},
    {name: "surgeons-new", path: "/surgeons/new", component: SurgeonsFormScreen},
    {name: "surgeons-edit", path: "/surgeons/edit/:surgeonId", component: SurgeonsFormScreen},
    {name: "surgeons-show", path: "/surgeons/show/:surgeonId", component: SurgeonsShowScreen},
    {name: "surgeries", path: "/surgeries", component: SurgeriesScreen},
    {name: "newSurgery", path: "/surgeries/new", component: NewSurgeryScreen},
    // Default redirect to home
    { path: "*", redirect: "/" }
  ],
  scrollBehavior() {
    return {x: 0, y: 0};
  }
});

// Redirect to login page if not logged in and trying to access a restricted page
router.beforeEach((to, from, next) => {
  const publicPages = ["/", "/login"],
    authRequired = (path) => {
      return !publicPages.includes(path);
    };

  if (authRequired(to.path) && !store.getters.getToken) {
    return next("/login");
  }

  next();
});

const store = new Vuex.Store({
  plugins: [createPersistedState()],
  state: initialState,
  getters,
  mutations,
  actions
});

export default store;

new Vue({
  el: '#app',
  store,
  router,
  template: '<App/>',
  components: { App }
});
