Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      namespace :scaffolding do
        namespace :completely_concrete do
          namespace :tangible_things do
            resources :targets_one_parent_actions
          end
        end
        namespace :absolutely_abstract do
          resources :creative_concepts do
            namespace :completely_concrete do
              namespace :tangible_things do
                resources :targets_one_parent_actions
              end
            end
          end
        end
      end
    end
  end

  collection_actions = [:index, :new, :create]
  extending = {only: []}

  namespace :api do
    namespace :v1 do
      shallow do
        resources :teams, extending do
          unless scaffolding_things_disabled?
            namespace :scaffolding do
              namespace :absolutely_abstract do
                resources :creative_concepts
              end
              resources :absolutely_abstract_creative_concepts, path: "absolutely_abstract/creative_concepts" do
                namespace :completely_concrete do
                  resources :tangible_things
                end
              end
            end
          end
        end
      end
    end
  end

  namespace :account do
    shallow do
      resources :teams do
        unless scaffolding_things_disabled?
          namespace :scaffolding do
            namespace :absolutely_abstract do
              resources :creative_concepts
            end
            resources :absolutely_abstract_creative_concepts, path: "absolutely_abstract/creative_concepts" do
              namespace :completely_concrete do
                resources :tangible_things
              end
            end
          end
        end
      end
    end
  end

end
