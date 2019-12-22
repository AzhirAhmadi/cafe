<template>
  <el-upload
    class="avatar-uploader"
    action="#"
    :auto-upload="false"
    :show-file-list="false"
    :on-change="handleChange"
    :before-upload="beforeAvatarUpload"
    >
    <img v-if="imageUrl" :src="imageUrl" class="avatar">
    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
  </el-upload>  
</template>

<script>
  export default {
    props:['image'],
    data() {
      return {
        imageUrl: '',
      };
    },
    methods: {
      beforeAvatarUpload(file) {
        const isJPG = file.type === 'image/jpeg';
        const isLt2M = file.size / 1024 / 1024 < 2;

        if (!isJPG) {
          this.$message.error('Avatar picture must be JPG format!');
        }
        if (!isLt2M) {
          this.$message.error('Avatar picture size can not exceed 2MB!');
        }
        return isJPG && isLt2M;
      },
      handleChange(file, fileList) {
        this.imageUrl = URL.createObjectURL(file.raw);
        this.$emit('onImageChange', file)
      },
    },
    created(){
      if(this.image != null){
        this.imageUrl = this.image.image.url
      }
    }
  }
</script>

<style>
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
  }
  .avatar {
    width: 178px;
    height: 178px;
    display: block;
  }
</style>