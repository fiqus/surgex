<template>
  <div id="surgeries-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 v-if="isNew" class="subtitle">Crear cirugía</h3>
      <h3 v-if="!isNew" class="subtitle">Editar cirugía</h3>
      <form class="form-custom" v-on:submit.prevent="submit" enctype="multipart/form-data">
        <div class="form-row">
          <div class="form-group col-md-6">
            <label>Fecha:</label>
            <input class="form-control" type="date" v-model="surgery.date">
            <label class="alert-danger" v-if="$v.surgery.date && $v.surgery.date.$error">Requerido</label>
          </div>
          <div class="form-group col-md-6">
            <label>Paciente:</label>
            <select class="form-control" v-model="surgery.patient.id">
              <option value="">- seleccionar -</option>
              <option v-for="patient in patients" :key="patient.key" :value="patient.key">{{patient.value}}</option>
            </select>
            <label class="alert-danger" v-if="$v.surgery.patient && $v.surgery.patient.id.$error">Requerido</label>
          </div>
          <div class="form-group col-md-6">
            <label>Cirujano:</label>
            <select class="form-control" v-model="surgery.surgeon.id">
              <option value="">- seleccionar -</option>
              <option v-for="surgeon in surgeons" :key="surgeon.key" :value="surgeon.key">{{surgeon.value}}</option>
            </select>
            <label class="alert-danger" v-if="$v.surgery.surgeon && $v.surgery.surgeon.id.$error">Requerido</label>
          </div>
          <div class="form-group col-md-6">
            <label>Diagnóstico:</label>
            <select class="form-control" v-model="surgery.diagnostic.id">
              <option value="">- sin diagnóstico -</option>
              <option v-for="diagnostic in diagnostics" :key="diagnostic.key" :value="diagnostic.key">{{diagnostic.value}}</option>
            </select>
          </div>
        </div>
        <div class="form-group">
          <label>Ayudantes:</label>
          <tagger-field 
            :first-option="'--'"
            :options="assistants"
            v-model="surgery.assistants">
          </tagger-field>
        </div>
         <div class="form-group">
          <label>Comentarios:</label>
          <textarea class="form-control" v-model="surgery.comments"></textarea>
        </div>
        <div class="form-group col-md-6" v-if="surgery.photos.length < 5">
          <label>Agregar fotos:</label>
          <input class="form-control" v-for="idx in Array.from({length: 5 - surgery.photos.length})" :key="idx" type="file" @change="addPhoto($event.target.files[0])">
        </div>

        <div class="form-group" v-if="!this.isNew">
          <label>Fotos actuales:</label>

          <div v-if="photoSelected" class="open-photo">
            <span class="close" v-on:click="closePhoto">&times;</span>
            <img class="open-photo-content" :src="photoSelected">
          </div>

          <div class="row text-center text-lg-left">
            <div class="col-lg-3 col-md-4 col-6" v-for="photo in surgery.photos" :key="photo.id">
              <div class="card" style="width: 300px; height: 300px;">
                <img class="img-thumbnail" style="height: 230px; width: 300px;" :src="photoUrl(photo)" v-on:click="openPhoto(photoUrl(photo))"/>
                <div class="card-body">
                  <i class="fa fa-trash" style="color: red;" v-on:click="removePhoto(photo)"></i>
                  <span class="d-inline-block text-truncate align-middle" style="max-width: 200px;">
                    Nombre: {{photo.name}}
                  </span>
                </div>
              </div>
            </div>
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
import TaggerField from "../../components/tagger-field";
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
        photos: []
      },
      added_photos: [],
      removed_photos: [],
      loading: true,
      isNew: !Boolean(this.$route.params.surgeryId),
      photoSelected: null
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
    return Promise.all([
      this.isNew ? Promise.resolve(null) : this.$store.dispatch("fetchSurgery", this.$route.params.surgeryId),
      this.$store.dispatch("fetchPatients"),
      this.$store.dispatch("fetchSurgeons"),
      this.$store.dispatch("fetchDiagnostics")
    ])
    .then(([surgery, patients, surgeons, diagnostics]) => {
      if (surgery) {
        this.surgery = surgery;
        this.surgery.diagnostic = surgery.diagnostic || {};
        this.surgery.photos = surgery.photos || [];
      }
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
    photoUrl(photo) {
      return `${this.$store.getters.getSurgeriesPhotosPath}${photo.name}`;
    },
    addPhoto(file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        this.added_photos.push({name: file.name, type: file.type, data: reader.result});
      };
      reader.readAsDataURL(file);
    },
    removePhoto(photo) {
      this.removed_photos.push(photo.id);
      this.surgery.photos = this.surgery.photos.filter((p) => p.id !== photo.id);
    },
    submit() {
      this.$v.$touch();

      if (!this.$v.$invalid) {
        const onSuccess = () => {
          this.$router.go(-1);
        };

        this.surgery.added_photos = this.added_photos;
        this.surgery.removed_photos = this.removed_photos;
        this.$store.dispatch(this.isNew ? "createSurgery" : "updateSurgery", {component: this, surgery: this.surgery, onSuccess});
      }
    },
    openPhoto(photo) {
      this.photoSelected = photo;
    },
    closePhoto() {
      this.photoSelected = null;
    }
  }
}
</script>

