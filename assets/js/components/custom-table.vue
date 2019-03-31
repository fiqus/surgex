<template>
  <div>
    <table class="custom-table">
      <thead>
        <th v-for="header in headers" :key="header.key">
          {{ header.value }}
        </th>
        <th v-if="!params.hideActions">Acciones</th>
      </thead>
      <tbody>
        <tr v-for="elem in data" :key="elem.id">
          <td class="cursor-pointer" v-for="header in headers" @click="onClick(elem)" :key="header.key">
            {{ parseElem(header, elem) }}
          </td>
          <td v-if="!params.hideActions">
            <a v-if="!params.hideEdit" @click="onEdit(elem)">Editar</a>
            <span v-if="!params.hideEdit && !params.hideDelete">|</span>
            <a v-if="!params.hideDelete" @click="onDelete(elem)">Eliminar</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
export default {
  props: {
    headers: {
      type: Array,
      default: [],
      required: true
    },
    data: {
      type: Array,
      default: [],
      required: true
    },
    params: {
      type: Object,
      default: {
        hideActions: false,
        hideEdit: false,
        hideDelete: false
      },
      required: false
    }
  },
  data() {
    return {
      parseElem(header, elem) {
        if (header.parser) {
            try {
              return header.parser(elem);
            } catch (err) {
              console.trace(`Can't parse the element for '${header.key}'!`, err);
            }
          }
          return elem[header.key];
      }
    };
  },
  computed: {
  },
  methods: {
    onClick(elem) {
      this.$emit("onClick", elem);
    },
    onEdit(elem) {
      this.$emit("onEdit", elem);
    },
    onDelete(elem) {
      this.$emit("onDelete", elem);
    }
  }
}
</script>

