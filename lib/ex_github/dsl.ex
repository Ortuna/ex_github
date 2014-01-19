defmodule ExGithub.DSL do
  defmacro __using__(opts) do
    quote do
      if unquote(opts)[:client] do
        @client unquote(opts)[:client]
      end

      import ExGithub.DSL, only: [ get: 2, 
                                   get_status: 2, 
                                   get_json: 2, 
                                   get_request: 3, 
                                   del: 2, 
                                   put: 2, 
                                   put_values: 2, 
                                   patch: 2, 
                                   post: 2 ]
    end 
  end
  
  defmacro get(fun_name, path) do
    quote do 
      def unquote(fun_name)(options // []) do
        @client.get(@client.http_library, unquote(path), options)
      end
    end
  end

  defmacro get_status(fun_name, path) do
    quote do 
      def unquote(fun_name)(options // []) do
        @client.get_status(@client.http_library, unquote(path), options)
      end
    end
  end

  defmacro get_request(fun_name, path, fun) do
    quote do 
      def unquote(fun_name)(options // []) do
        response = @client.get_request(@client.http_library, unquote(path), options)
        unquote(fun).(response)
      end
    end
  end


  defmacro get_json(fun_name, path) do
    quote do 
      def unquote(fun_name)(options // []) do
        @client.get_json(@client.http_library, unquote(path), options)
      end
    end
  end

  defmacro del(fun_name, path) do
    quote do 
      def unquote(fun_name)(options // []) do
        @client.delete(@client.http_library, unquote(path), options)
      end
    end
  end

  defmacro put(fun_name, path) do
    quote do 
      def unquote(fun_name)(options // []) do
        @client.put(@client.http_library, unquote(path), options)
      end
    end
  end

  defmacro put_values(fun_name, path) do
    quote do 
      def unquote(fun_name)(values, options // []) do
        @client.put_values(@client.http_library, unquote(path), values, options)
      end
    end
  end

 
  defmacro patch(fun_name, path) do
    quote do 
      def unquote(fun_name)(values, options // []) do
        @client.patch(@client.http_library, unquote(path), values, options)
      end
    end
  end

  defmacro post(fun_name, path) do
    quote do 
      def unquote(fun_name)(values, options // []) do
        @client.post(@client.http_library, unquote(path), values, options)
      end
    end
  end

end
