// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

import "phoenix_html"
import Vue from "vue"
import VueRouter from "vue-router"
import Vuex from "vuex"
import createPersistedState from "vuex-persistedstate";

import {initialState, getters, mutations, actions} from "./state/store";

import App from "./App"

import HomeScreen from "./screens/home.vue";
import LoginScreen from "./screens/login.vue";
import PatientsScreen from "./screens/patients.vue";
import PatientScreen from "./screens/patient.vue";
import UsersListScreen from "./screens/users-list.vue";
import UsersShowScreen from "./screens/users-show.vue";
import SurgeriesScreen from "./screens/sugeries.vue";

Vue.config.debug = true;
Vue.config.devtools = true;
Vue.config.silent = false;

Vue.use(VueRouter)
Vue.use(Vuex)

const router = new VueRouter({
  routes: [
    {name: "home", path: "/", component: HomeScreen},
    {name: "login", path: "/login", component: LoginScreen},
    {name: "patients", path: "/patients", component: PatientsScreen},
    {name: "patient", path: "/patient/:patientId", component: PatientScreen},
    {name: "users-list", path: "/users", component: UsersListScreen},
    {name: "users-show", path: "/users/:userId", component: UsersShowScreen},
    {name: "surgeries", path: "/surgeries", component: SurgeriesScreen},
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
