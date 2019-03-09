import HomeScreen from "./screens/home.vue";
import LoginScreen from "./screens/login.vue";
import RecoverScreen from "./screens/recover.vue";
import ActivateScreen from "./screens/activate.vue";
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

export default [
  {name: "home", path: "/", component: HomeScreen, meta: {access: "public"}},
  {name: "login", path: "/login", component: LoginScreen, meta: {access: "public"}},
  {name: "recover", path: "/users/recover", component: RecoverScreen, meta: {access: "public"}},
  {name: "activate", path: "/users/activate", component: ActivateScreen, meta: {access: "public"}},
  {name: "users-list", path: "/users", component: UsersListScreen},
  {name: "users-show", path: "/users/:userId", component: UsersShowScreen},
  {name: "users-edit", path: "/users/edit/:userId", component: UsersEditScreen},
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
];
