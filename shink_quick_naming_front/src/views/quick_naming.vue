<template>
  <div>
    快速命名分层
    <div class="btn btn-default" @click.stop="test">测试</div>
  </div>
</template>



<script>
  export default {
    methods: {
      test() {
        su_alert('测试')
      }
    }
  }
</script>
