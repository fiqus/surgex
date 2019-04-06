<template>
  <div id="patients-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <!--customForm
      :formName="'Nuevo Paciente'"
      :fields="this.fields"
      @create="newPatient">
      </customForm>
      <button-- v-on:click="backToList" class="btn btn-primary">
        <i class="fa fa-caret-left"></i>
        Volver al listado
      </button-->
      <h3 v-if="isNew" class="subtitle">Crear Paciente</h3>
      <h3 v-if="!isNew" class="subtitle">Editar paciente: {{ formatFullName(patient) }}</h3>
      <form v-on:submit="submit">
        <div class="form-patient">
          <div>
            <label>Nombre:</label>
            <input type="text" v-model="patient.firstName">
          </div>
          <div>
            <label>Apellido:</label>
            <input type="text" v-model="patient.lastName">
          </div>
          <div>
            <label>DNI:</label>
            <input type="text" v-model="patient.socialId">
          </div>
          <div>
            <label>Historia Clínica:</label>
            <input type="text" v-model="patient.medicalHistory">
          </div>
          <div>
            <label>Email:</label>
            <input type="text" v-model="patient.email">
          </div>
          <div>
            <label>Teléfono:</label>
            <input type="text" v-model="patient.phone">
          </div>
          <div>
            <label>Fecha de Nacimiento:</label>
            <input type="date" v-model="patient.birthdate">
          </div>
          <div>
            <label>Nacionalidad:</label>
            <input type="text" v-model="patient.nationality">
          </div>
          <div>
            <label>Dirección:</label>
            <input type="text" v-model="patient.address">
          </div>
          <div>
            <label>Ciudad:</label>
            <input type="text" v-model="patient.city">
          </div>
          <div>
            <label>Provincia:</label>
            <input type="text" v-model="patient.province">
          </div>
          <div class="action-bar-buttons">
            <button type="button" class="btn btn-primary" @click="$router.go(-1)"><i class="fa fa-arrow-left"></i> Cancelar</button>
            <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Guardar</button>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>
<script>
import customForm from "../../components/custom-form";
import {formatFullName} from "../../utils";
export default {
	components: {
		customForm
	},
  data() {
    return {
      patient: {},
      loading: true,
      isNew: !Boolean(this.$route.params.patientId),
      action: "/api/patients",
      formatFullName
      // fields: [
      //   {key: "firstName", placeholder: "Nombre"},
      //   {key: "lastName", placeholder: "Apellido"},
      //   {key: "medical_history", placeholder: "Historia Clínica"}, 
      //   {key: "address", placeholder: "Dirección"},
      //   {key: "city", placeholder: "Ciudad"},
      //   {key: "province", placeholder: "Provincia"},
      //   {key: "birthdate", type: "date"}
      // ]
    }
  },
  created() {
    if (this.isNew) {
      this.loading = false;
      this.action = `${this.action}/new`;
    } else {
      this.action = `${this.action}/edit/${this.$route.params.patientId}`;
      this.$store.dispatch("fetchPatient", this.$route.params.patientId)
        .then((patient) => {
          this.patient = patient;
          this.loading = false;
        });
    }
  },
	methods: {
    submit: function (event) {
      event.preventDefault();
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch(this.isNew ? "createPatient" : "updatePatient", {component: this, patient: this.patient, onSuccess});
    }
	}
}
</script>
