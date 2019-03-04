<template>
  <div>
    <h3 class="subtitle">Crear cirugia</h3>
    <form v-on:submit="submit">
      <div class="form-user">
        <div>
          <label>Fecha:</label>
          <input type="date" v-model="surgery.date">
          <label class="alert-danger" v-if="$v.surgery.date.$error">Requerido</label>
        </div>
        <div>
          <label>Cirujano:</label>
          <select v-model="surgery.surgeon_id">
            <option value="">Seleccione un cirujano</option>
            <option v-for="surgeon in surgeons" :key="surgeon.key" :value="surgeon.key">{{surgeon.value}}</option>
          </select>
          <label class="alert-danger" v-if="$v.surgery.surgeon_id.$error">Requerido</label>
        </div>
        <div>
          <label>Paciente:</label>
          <select v-model="surgery.patient_id">
            <option value="">Seleccione un paciente</option>
            <option v-for="patient in patients" :key="patient.key" :value="patient.key">{{patient.value}}</option>
          </select>
          <label class="alert-danger" v-if="$v.surgery.patient_id.$error">Requerido</label>
        </div>
        <div>
          <label>Ayudantes:</label>
          <tagger-field
            :first-option="'Elija un ayudante'"
            :options="surgeons"
            v-model="surgery.assistants">
          </tagger-field>
        </div>
      </div>
      <div class="action-bar-buttons">
        <button type="button" class="button" @click="$router.go(-1)"><i class="fa fa-arrow-left"></i> Cancelar</button>
        <button type="submit" class="button"><i class="fa fa-save"></i> Guardar</button>
      </div>
		</form>
  </div>
</template>
<script>
  import TaggerField from "../../components/tagger-field.vue";
  import {required} from "vuelidate/lib/validators";

  function formatToSelect(list, fnValue) {
    return list.map((obj) => {
      return {
        key: obj.id,
        value: fnValue()
      }
    });
  }

  export default {
    components: {
      TaggerField
    },
    created() {
      return Promise.all([
        this.$store.dispatch("fetchPatients"),
        this.$store.dispatch("fetchSurgeons")
      ])
      .then(([patients, surgeons]) => {
        this.patients = patients.map((obj) => {
          return {
            key: obj.id,
            value: `${obj.first_name} ${obj.last_name}`
          }
        });
        this.surgeons = surgeons.map((obj) => {
          return {
            key: obj.id,
            value: `${obj.firstName} ${obj.lastName}`
          }
        });
      });
    },
    methods: {
      backToList() {
        this.$router.push({name: "surgeries-list"});
      },
      submit() {
        this.$v.$touch();

        if (!this.$v.$invalid) {
          this.$store.dispatch("createSurgery", {component: this, surgery: this.surgery, onSuccess: this.backToList});
        }
      }
    },
    data() {
      return {
        patients: [],
        surgeons: [],
        surgery: {
          "date": "",
          "surgeon_id": "",
          "patient_id": "",
          "assistants": []
        }
      }
    },
    validations: {
      surgery: {
        "surgeon_id": {required},
        "patient_id": {required},
        "date": {required}
      }
    }
  }
</script>

