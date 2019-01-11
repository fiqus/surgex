// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

import "phoenix_html"
import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex from 'vuex'

import {initialState, getters, mutations, actions} from "./state/store";

import App from './App'

import HomeScreen from "./screens/home.vue";
import PatientScreen from "./screens/patient.vue";

Vue.config.debug = true;
Vue.config.devtools = true;
Vue.config.silent = false;

Vue.use(VueRouter)
Vue.use(Vuex)

const router = new VueRouter({
  routes: [
    {name: "home", path: "/", component: HomeScreen},
    {name: 'patient', path: '/patient/:patientId', component: PatientScreen},
  ],
  scrollBehavior() {
    return {x: 0, y: 0};
  }
});

const store = new Vuex.Store({
  state: initialState,
  getters,
  mutations,
  actions
});

new Vue({
  el: '#app',
  store,
  router,
  template: '<App/>',
  components: { App }
});