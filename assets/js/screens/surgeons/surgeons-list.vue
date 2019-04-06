<template>
  <div id="surgeons-list">
    <h3 class="subtitle">Listado de Cirujanos</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <button class="btn btn-primary float-right" v-if="isAdmin" v-on:click="showNew">
        <i class="fa fa-plus"></i>
        Agregar Cirujano
      </button>
      <customTable 
        v-if="surgeons.length"
        :params="params"
        :headers="headers"
        :data="surgeons"
        @onClick="showDetail"
        @onEdit="showEdit"
        @onDelete="onDelete">
      </customTable>
      <h4 v-if="!surgeons.length">Aún no hay cirujanos ingresados.</h4>
    </div>
  </div>
</template>
<script>
import customTable from "../../components/custom-table";
import {formatFullName} from "../../utils";
export default {
  components: {
    customTable
  },
  data() {
    return {
      params: {},
      headers: [
        {key: "fullName", value: "Cirujano", parser: formatFullName},
        {key: "email", value: "Email"},
        {key: "phone", value: "Teléfono"}
      ],
      surgeons: [],
      loading: true
    }
  },
  created() {
    this.params.hideActions = !this.isAdmin;
    this.$store.dispatch("fetchSurgeons")
      .then((surgeons) => {
        this.surgeons = surgeons;
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
    showNew() {
      this.$router.push({name: "surgeons-new"});
    },
    showDetail(surgeon) {
      this.$router.push({name: "surgeons-show", params: {surgeonId: surgeon.id}});
    },
    showEdit(surgeon) {
      this.$router.push({name: "surgeons-edit", params: {surgeonId: surgeon.id}});
    },
    onDelete(surgeon) {
      const onSuccess = () => {
        this.surgeons = this.surgeons.filter((s) => {
          return s.id !== surgeon.id;
        });
      };

      this.$store.dispatch("deleteSurgeon", {component: this, surgeon, onSuccess});
    }
  }
}
</script>
