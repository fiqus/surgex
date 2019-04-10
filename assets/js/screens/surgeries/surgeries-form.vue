<template>
  <div id="surgeries-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 v-if="isNew" class="subtitle">Crear cirugía</h3>
      <h3 v-if="!isNew" class="subtitle">Editar cirugía</h3>
      <form v-on:submit.prevent="submit" enctype="multipart/form-data">
        <div class="form-user">
          <div class="form-field-container">
            <label>Fecha:</label>
            <input type="date" v-model="surgery.date">
            <label class="alert-danger" v-if="$v.surgery.date && $v.surgery.date.$error">Requerido</label>
          </div>
          <div class="form-field-container">
            <label>Paciente:</label>
            <select v-model="surgery.patient.id">
              <option value="">- seleccionar -</option>
              <option v-for="patient in patients" :key="patient.key" :value="patient.key">{{patient.value}}</option>
            </select>
            <label class="alert-danger" v-if="$v.surgery.patient && $v.surgery.patient.id.$error">Requerido</label>
          </div>
          <div class="form-field-container">
            <label>Cirujano:</label>
            <select v-model="surgery.surgeon.id">
              <option value="">- seleccionar -</option>
              <option v-for="surgeon in surgeons" :key="surgeon.key" :value="surgeon.key">{{surgeon.value}}</option>
            </select>
            <label class="alert-danger" v-if="$v.surgery.surgeon && $v.surgery.surgeon.id.$error">Requerido</label>
          </div>
          <div class="form-field-container">
            <label>Ayudantes:</label>
            <tagger-field
              :first-option="'--'"
              :options="assistants"
              v-model="surgery.assistants">
            </tagger-field>
          </div>
          <div class="form-field-container">
            <label>Diagnóstico:</label>
            <select v-model="surgery.diagnostic.id">
              <option value="">- sin diagnóstico -</option>
              <option v-for="diagnostic in diagnostics" :key="diagnostic.key" :value="diagnostic.key">{{diagnostic.value}}</option>
            </select>
          </div>
          <div class="form-field-container">
            <label>Fotos:</label>
            <input v-for="(photo, photoIdx) in surgery.encoded_photos" :key="photoIdx" type="file" @change="addPhoto($event, photoIdx)">
          </div>
        </div>
        <div class="action-bar-buttons">
          <button type="button" class="btn btn-secondary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Cancelar</button>
          <button type="submit" class="btn btn-success"><i class="fa fa-save"></i> Guardar</button>
        </div>
      </form>
    </div>
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
  data() {
    return {
      patients: [],
      surgeons: [],
      diagnostics: [],
      surgery: {
        patient: {},
        surgeon: {},
        assistants: [],
        diagnostic: {},
        encoded_photos: ["", "", ""] // @TODO WIPPPPPPPPPPPPP!!!!!!!
      },
      loading: true,
      isNew: !Boolean(this.$route.params.surgeryId)
    }
  },
  validations: {
    surgery: {
      // "surgeon.id": {required}, // @TODO Doesn't work!
      // "patient.id": {required}, // @TODO Doesn't work!
      "date": {required}
    }
  },
  created() {
    if (!this.isNew) {
      this.$store.dispatch("fetchSurgery", this.$route.params.surgeryId)
        .then((surgery) => {
          this.surgery = surgery;
        });
    }
    
    return Promise.all([
      this.$store.dispatch("fetchPatients"),
      this.$store.dispatch("fetchSurgeons"),
      this.$store.dispatch("fetchDiagnostics")
    ])
    .then(([patients, surgeons, diagnostics]) => {
      this.patients = patients.map((obj) => {
        return {
          key: obj.id,
          value: `${formatFullName(obj)} --- HC: ${obj.medical_history || "-"}`
        }
      });
      this.surgeons = surgeons.map((obj) => {
        return {
          key: obj.id,
          value: formatFullName(obj)
        }
      });
      this.diagnostics = diagnostics.map((obj) => {
        return {
          key: obj.id,
          value: obj.name
        }
      });

      this.loading = false;
    });
  },
  computed: {
    assistants: {
      get() {
        const assistants = this.surgery.surgeon.id
          ? this.surgeons.filter(s => this.surgery.surgeon.id !== s.key)
          : this.surgeons;

        // Filter selected surgery assistants removing those that are not available anymore (because it was selected as surgeon)
        this.surgery.assistants = this.surgery.assistants.filter(({id}) => assistants.find(a => a.key === id));
        return assistants;
      }
    }
  },
  methods: {
    addPhoto(event, idx) {
      const reader = new FileReader();
      reader.onloadend = () => {
        this.surgery.encoded_photos[idx] = reader.result;
      }
      reader.readAsDataURL(event.target.files[0]);
    },
    submit() {
      this.$v.$touch();

      if (!this.$v.$invalid) {
        const onSuccess = () => {
          this.$router.go(-1);
        };
        this.$store.dispatch(this.isNew ? "createSurgery" : "updateSurgery", {component: this, surgery: this.surgery, onSuccess});
      }
    }
  }
}
</script>

