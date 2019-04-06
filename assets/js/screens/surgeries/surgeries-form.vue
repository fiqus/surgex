<template>
  <div id="surgeries-form">
    <h3 class="subtitle">Crear Cirugía</h3>
    <form v-on:submit.prevent="submit" enctype="multipart/form-data">
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
        <div>
          <label>Fotos:</label>
          <input v-for="(photo, photoIdx) in surgery.encoded_photos" :key="photoIdx" type="file" @change="addPhoto($event, photoIdx)">
        </div>
      </div>
      <div class="action-bar-buttons">
        <button type="button" class="btn btn-primary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Cancelar</button>
        <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Guardar</button>
      </div>
		</form>
  </div>
</template>
<script>
import TaggerField from "../../components/tagger-field.vue";
import {required} from "vuelidate/lib/validators";
import {formatFullName} from "../../utils";

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
          value: formatFullName(obj)
        }
      });
      this.surgeons = surgeons.map((obj) => {
        return {
          key: obj.id,
          value: formatFullName(obj)
        }
      });
    });
  },
  methods: {
    addPhoto(event, idx) {
      const reader = new FileReader();
      reader.onloadend = () => {
        this.surgery.encoded_photos[idx] = reader.result;
      }
      reader.readAsDataURL(event.target.files[0]);
    },
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
        "assistants": [],
        "encoded_photos": ["", "", ""]
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

