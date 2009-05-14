%module liblinear
%{
#include "linear.h"
%}

struct feature_node
{
	int index;
	double value;
};

struct problem
{
	int l, n;
	int *y;
	struct feature_node **x;
	double bias;            /* < 0 if no bias term */  
};

enum { L2_LR, L2LOSS_SVM_DUAL, L2LOSS_SVM, L1LOSS_SVM_DUAL, MCSVM_CS }; /* solver_type */

struct parameter
{
	int solver_type;

	/* these are for training only */
	double eps;	        /* stopping criteria */
	double C;
	int nr_weight;
	int *weight_label;
	double* weight;
};

struct model
{
	struct parameter param;
	int nr_class;		/* number of classes */
	int nr_feature;
	double *w;
	int *label;		/* label of each class (label[n]) */
	double bias;
};

struct model* train(const struct problem *prob, const struct parameter *param);
void cross_validation(const struct problem *prob, const struct parameter *param, int nr_fold, int *target);

int predict_values(const struct model *model_, const struct feature_node *x, double* dec_values);
int predict(const struct model *model_, const struct feature_node *x);
int predict_probability(const struct model *model_, const struct feature_node *x, double* prob_estimates);

int save_model(const char *model_file_name, const struct model *model_);
struct model *load_model(const char *model_file_name);

int get_nr_feature(const struct model *model_);
int get_nr_class(const struct model *model_);
void get_labels(const struct model *model_, int* label);

void destroy_model(struct model *model_);
void destroy_param(struct parameter *param);
const char *check_parameter(const struct problem *prob, const struct parameter *param);

%include carrays.i		
%array_functions(int,int)
%array_functions(double,double)


%inline %{
extern int info_on;

struct feature_node *feature_node_array(int size)
{
	return (struct feature_node *)malloc(sizeof(struct feature_node)*size);
}

void feature_node_array_set(struct feature_node *array, int i, int index, double value)
{
	array[i].index = index;
	array[i].value = value;
}

void feature_node_array_destroy(struct feature_node *array)
{
	free(array);
}

struct feature_node **feature_node_matrix(int size)
{
	return (struct feature_node **)malloc(sizeof(struct feature_node *)*size);	
}

void feature_node_matrix_set(struct feature_node **matrix, int i, struct feature_node* array)
{
	matrix[i] = array;
}

void feature_node_matrix_destroy(struct feature_node **matrix)
{
	free(matrix);
}

%}
