<template>
  <div>
    <table class="custom-table">
      <thead>
        <th v-for="header in headers" :key="header.key">
          {{ header.value }}
        </th>
        <th>Acciones</th>
      </thead>
      <tbody>
        <tr style="cursor: pointer" v-for="elem in data" :key="elem.id">
          <td v-for="header in headers" @click="onClick(elem)" :key="header.key">
            {{ parseElem(header, elem) }}
          </td>
          <td>
            <a @click="onEdit(elem)">Editar</a>
            |
            <a @click="onDelete(elem)">Eliminar</a>
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

