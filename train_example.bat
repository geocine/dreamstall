
@CALL "%~dp0root\condabin\micromamba.bat" activate diffusers

accelerate launch --config_file %~dp0default_config.yaml --num_cpu_threads_per_process 6 train_dreambooth.py ^
  --pretrained_model_name_or_path="runwayml/stable-diffusion-v1-5" ^
  --pretrained_vae_name_or_path="stabilityai/sd-vae-ft-mse" ^
  --output_dir="./train/dog/output" ^
  --with_prior_preservation --prior_loss_weight=1.0 ^
  --seed=494481440 ^
  --resolution=512 ^
  --train_batch_size=1 ^
  --train_text_encoder ^
  --mixed_precision="fp16" ^
  --use_8bit_adam ^
  --gradient_checkpointing ^
  --gradient_accumulation_steps=1 ^
  --learning_rate=1e-6 ^
  --lr_scheduler="constant" ^
  --lr_warmup_steps=0 ^
  --num_class_images=500 ^
  --sample_batch_size=4 ^
  --max_train_steps=800 ^
  --save_interval=200 ^
  --save_sample_prompt="photograph of zwx dog" ^
  --concepts_list="concepts_list.json" ^
  --save_guidance_scale=7.5 ^
  --n_save_sample=10 ^
  --save_infer_steps=50 ^
  --save_min_steps=800
pause