<template>
  <div id="patients-show">
    <h3 class="subtitle">Detalle del Paciente</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <section class="elem-details">
        <div><b>Paciente:</b> {{patient.lastName}}, {{patient.firstName}}</div>
        <div><b>DNI:</b> {{patient.socialId || "-"}}</div>
        <div><b>Historia Clínica:</b> {{patient.medicalHistory || "-"}}</div>
        <div><b>Email:</b> {{patient.email || "-"}}</div>
        <div><b>Teléfono:</b> {{patient.phone || "-"}}</div>
        <div><b>Fecha Nacimiento:</b> {{patient.birthdate || "-"}}</div>
        <div><b>Nacionalidad:</b> {{patient.nationality || "-"}}</div>
        <div><b>Dirección:</b> {{patient.address || "-"}}</div>
        <div><b>Ciudad:</b> {{patient.city || "-"}}</div>
        <div><b>Provincia:</b> {{patient.province || "-"}}</div>
      </section>
      <div class="action-bar-buttons">
        <button class="button" @click="$router.go(-1)"><i class="fa fa-arrow-left"></i> Volver</button>
        <button class="button" @click="showEdit(patient)" v-if="isAdmin"><i class="fa fa-edit"></i> Editar</button>
        <button class="button" @click="onDelete(patient)" v-if="isAdmin"><i class="fa fa-trash"></i> Eliminar</button>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      patient: null,
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchPatient", this.$route.params.patientId)
      .then((patient) => {
        this.patient = patient;
        this.loading = false;
      });
  },
  computed: {
    isAdmin: {
      get() {
        return this.$store.getters.isAdmin;
      }
    }
  },
  methods: {
    showEdit(patient) {
      this.$router.push({name: "patients-edit", params: {patientId: patient.id}});
    },
    onDelete(patient) {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch("deletePatient", {component: this, patient, onSuccess});
    }
  }
}
</script>
