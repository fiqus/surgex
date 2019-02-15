<template>
  <div>
    <h3 class="subtitle">Listado de Pacientes</h3>
    <customTable 
      v-if="this.patients"
      :headers="this.headers"
      :data="this.patients"
      @clicked="patientSelect"
      @deleteRow="confirmDelete">
    </customTable>
    <button class="button" v-on:click="createPatient">
      <i class="fa fa-plus"></i>
      Agregar Paciente
    </button>
    <h4 v-if="!this.patients">Aún no tiene Pacientes cargados</h4>
  </div>
</template>

<script>
import customTable from "../../components/custom-table";
export default {
  components: {
    customTable
  },
  created() {
    this.$store.dispatch("fetchPatients")
      .then((patients) => {
        if(patients.length) {
          this.patients = patients;
        }
      });
  },
  data() {
    return {
      headers: [
        {key: "first_name", value: "Nombre"}, 
        {key: "last_name", value: "Apellido"}, 
        {key: "address", value: "Dirección"},
        {key: "city", value: "Ciudad"},
        {key: "province", value: "Provincia"},
        {key: "birthdate", value: "Fecha de Nacimiento"}
      ],
      patients: null,
      patientSelected: null
    }
  },
  computed: {
  },
  methods: {
    patientSelect(id) {
      return this.$router.push({path: `patient/${id}`});
    },
    createPatient() {
      return this.$router.push({name: "new-patient"});
    },
    deletePatient() {
      this.$store.dispatch("deletePatient", this.patientSelected)
        .then(() => {
          this.$router.go(0);
        })
        .catch((_) => {
          this.$awn.alert("Error al borrar el Paciente")
        });
    },
    confirmDelete: function(id) {
      this.patientSelected = id;
      this.$awn.confirm("¿Esta seguro que desea eliminar un Paciente?", this.deletePatient);
    }
  }
}
</script>
