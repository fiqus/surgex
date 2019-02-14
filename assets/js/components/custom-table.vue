<template>
  <div>
    <table>
      <th
        v-for="header in headers"
        :key="header">
          {{ header.value }}
      </th>
      <tr 
        v-for="d in data"
        :key="d">
        <td style="cursor: pointer"
          v-for="header in headers"
          :key="header"
          v-on:click="clicked(d.id)">
            {{ d[header.key] }}
        </td>
        <td v-on:click="deleteRow(d.id)">
          <i class="fa fa-trash-o"></i>
        </td>
      </tr>
    </table>
  </div>
</template>
<script>
export default {
  props: {
    headers: {
      type: Array,
      default: [],
      required: true,
    },
    data: {
      type: Array,
      default: [],
      required: true,
    }
  },
  data() {
    return {
    }
  },
  computed: {
  },
  methods: {
    clicked(id) {
      this.$emit("clicked", id);
    },
    deleteRow(id) {
      this.$emit("deleteRow", id);
    }
  }
}
</script>

