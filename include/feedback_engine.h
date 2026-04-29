#ifndef FEEDBACK_ENGINE_H
#define FEEDBACK_ENGINE_H

void feedback_init();

void update_weight(const char* keyword,
                   const char* correct_category,
                   float delta);

float get_weight(const char* keyword,
                 const char* category);

void save_weights(const char* filepath);

void load_weights(const char* filepath);

#endif