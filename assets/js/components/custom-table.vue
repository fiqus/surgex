<template>
  <div>
    <table>
      <th
        v-for="header in headers">
          {{ header.value }}
      </th>
      <tr 
        v-for="d in data">
        <td style="cursor: pointer"
          v-for="header in headers"
          v-on:click="clicked(d.id)">
            {{ d[header.key] }}
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
    }
  }
}
</script>
