<template>
  <div id="patients-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 v-if="isNew" class="subtitle">Crear Paciente</h3>
      <h3 v-if="!isNew" class="subtitle">Editar paciente: {{ formatFullName(patient) }}</h3>
      <customForm
        :fields="fields"
        :data="patient"
        @onSubmit="submit">
      </customForm>
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
      fields: [
        {key: "first_name", label: "Nombre"},
        {key: "last_name", label: "Apellido"},
        {key: "social_id", label: "DNI"},
        {key: "medical_history", label: "Historia Clínica"},
        {key: "email", label: "Email"},
        {key: "phone", label: "Teléfono"},
        {key: "birthdate", label: "Fecha de Nacimiento", type: "date"},
        {key: "nationality", label: "Nacionalidad"},
        {key: "address", label: "Dirección"},
        {key: "city", label: "Ciudad"},
        {key: "province", label: "Provincia"}
      ],
      formatFullName
    }
  },
  created() {
    if (this.isNew) {
      this.loading = false;
    } else {
      this.$store.dispatch("fetchPatient", this.$route.params.patientId)
        .then((patient) => {
          this.patient = patient;
          this.loading = false;
        });
    }
  },
	methods: {
    submit: function () {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch(this.isNew ? "createPatient" : "updatePatient", {component: this, patient: this.patient, onSuccess});
    }
	}
}
</script>
