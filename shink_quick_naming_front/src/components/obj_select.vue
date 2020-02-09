<template>
  <div class="tag" v-bind:style="{width: width}">
    <div style="min-height: 25px;" @click.stop="toggle">
      <span v-if="chosed_obj" class="tag-name">{{chosed_obj.name}}</span>
      <span v-else class="tag-name" style="color: #C7C7CD">{{tip}}</span>
      <span class="zhankai">
        <div class="angle_scale_ud">{{open ? '∧':'∨'}}</div>
      </span>
    </div>
    <div v-if="open" class="user-box shadow_box" v-bind:style="{width: width}" @mouseleave="toggle">
      <template v-if="arr.length > 0">
        <input type="text" ref="search_word" class="search-word" v-model="search_word">
        <ul class="tag-list">
          <li v-for="obj in search_result" :class="{active : is_chosed(obj)}">
            <label @click.stop="chose_obj(obj)">{{obj.name}}</label>
          </li>
        </ul>
      </template>
      <ul v-else class="tag-list">
        <li style="color: #C7C7CD">无数据</li>
      </ul>
    </div>
  </div>
</template>

<script>
  export default{
    props: {
      value: {
        type: null,
        required: true
      },
      arr: {
        type: Array,
        required: true
      },
      width: {
        type: String,
        default: '162px'
      },
      tip: {
        type: String,
        default: '请选择'
      }
    },
    data(){
      return {
        open: false,
        search_word: null
      }
    },
    created(){

    },
    computed: {
      chosed_obj: function () {
        let find_result = this.arr.filter((p)=>{return p.id == this.value})
        return find_result.length > 0 ? find_result[0] : null
      },
      search_result: function () {
        return this.search_word ? this.arr.filter((p)=>{return p.name.indexOf(this.search_word) > -1}) : this.arr
      }
    },
    methods:{
      toggle(){
        this.open = !this.open
        if (this.open && this.arr.length > 0) {
          this.search_word = null
          Vue.nextTick(() => {
            this.$refs.search_word.focus()
          })
        }
      },
      is_chosed(obj){
        return this.value ? this.value == obj.id : false
      },
      chose_obj(obj){
        this.set_value(obj.id)
        this.open = false
      },
      set_value(value){
        this.$emit('input', value)
      }
    }
  }
</script>

<style scoped>
  .tag{
    min-height: 25px;
    border: 1px solid #BBBBBB;
    position: relative;
    cursor: pointer;
    padding-right: 20px;
  }
  .tag-name{
    display: inline-block;
    padding: 0px 5px;
    height: 20px;
    line-height: 20px;
    margin-top: 2px;
    margin-bottom: 1px;
    border-radius: 4px;
    margin-left: 5px;
  }
  .tag-name > i{
    position: relative;
    z-index: 15;
    cursor: pointer;
    margin-left: 3px;
    color: #999;
  }
  .tag-name > i:hover{
    color: #444;
  }
  .zhankai{
    position: absolute;
    right: 10px;
    top: 0;
    line-height: 20px;
  }
  .user-box{
    position: absolute;
    top: 120%;
    left: -1px;
    z-index: 1000;
    background-color: #fff;
  }
  .tag-list{
    max-height: 162px;
    overflow-y: auto;
    line-height: 30px;
    padding: 2px 0px ;
  }
  .tag-list > li{
    overflow: hidden;
    padding-left: 10px;
    position: relative;
  }
  .tag-list > li > span{
    position: absolute;
    right: 10px;
    top: 8px;
  }
  .tag-list > li:hover{
    background-color: #f5f7fa;
  }
  .tag-list > li.active{
    background-color: #f5f7fa;
  }
  .tag-list label{
    font-weight: 400;
    display: block;
  }
  .search-word{
    width: 98%;
    margin: 3px;
    line-height: 20px;
    height: 24px;
  }
  .select-user-avatar{
    width: 24px;
    height: 24px;
    margin-top: 4px;
    margin-right: 8px;
    border-radius: 15px;
    background-color: #fff;
    float: left;
  }
</style>
